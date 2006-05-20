#!/usr/bin/perl -w

use strict;

use Getopt::Std;

my %opt;

getopts('o:i:s:t:h', \%opt);

if ($opt{'h'} or ! ($opt{'o'} and $opt{'i'} and $opt{'s'} and $opt{'t'}) ) {
    print "USAGE: $0 -i <input file> -o <output file> -s <selectors file> -t <theme name>\n";
    print "Options:\n";
    print "\t-h\tPrint this message\n";
    print "\t-i\tThe CSS file to read\n";
    print "\t-o\tThe file to write the SQL to\n";
    print "\t-s\tA file containing a list of selectors to extract styles for\n";
    print "\t-t\tThe name of the theme\n";
    exit(1);
}

my %selectors;

read_selectors($opt{'s'},\%selectors);

parse_css_file($opt{'i'},\%selectors);

print_sql_file($opt{'o'},\%selectors);

sub read_selectors {
    my $filename = shift;
    my $selectors_hash = shift;

    print "Reading selectors from $filename\n";

    open my $selector_file, '<', $filename or die "Could not open $filename for read: $!";
    my @selectors = <$selector_file>;
    close $selector_file;

    foreach my $selector (@selectors) {
	chomp $selector;
	$selectors_hash->{$selector} = 0;
    }

    print "Read ", $#selectors+1, " selectors from $filename\n";
}

sub parse_css_file {
    my $filename = shift;
    my $selectors_hash = shift;

    open my $css_file, '<', $filename or die "Could not open $filename for read: $!";
    my @css_lines = <$css_file>;
    close $css_file;
    
    my $in_comment;
    my $in_body;
    my $starting_body;
    my $buffer;

    my @selectors;
    my $selectors_raw;

    my $line_number = 0;

    foreach my $line (@css_lines) {
	#first, handle comments
	$buffer .= $line;
	$line_number++;
	if ($line =~ m|/\*|) {
	    $in_comment = 1;
	}
	if ($line =~ m|\*/|) {
	    $in_comment = 0;
	}
	next if $in_comment;
	$buffer =~ s|/\*.*\*/||s;

	#skip blank lines
	next if $buffer =~ /^\s*$/;

	#now handle selectors
	unless ($in_body) {
	    # if there's {, extract every thing up to it
	    if ($buffer =~ /\{/) {
		$selectors_raw .= substr($buffer,0,(index($buffer,'{')),'');
		$starting_body = 1;
	    } else {
		$selectors_raw .= $buffer;
		$buffer = "";
	    }
	    next unless $starting_body;
	    $selectors_raw =~ s/\s//g; #kill whitespace
	    $selectors_raw =~ s/\n//g; #kill newlines
	    $selectors_raw =~ s/\r//g; #kiil carriage returns, just in case
	    @selectors = split(/,/,$selectors_raw);
	    $starting_body = 0; # we're no longer starting the body,
	    $in_body = 1; # the rest of the buffer is _in_ the body.
	    $selectors_raw = "";
	    print "Extracted selectors ", join(' ',@selectors), " from $selectors_raw at line $line_number\n";
	}
	
	# check to see if the buffer contains the end of the style
	if ( $buffer =~ /\}/ ) {
            # the +1 is to get the } itself; if } was at pos 3, then
	    # you start at 0 and get 3 chars -- 0,1,2, leaving } in the buffer
	    my $body = substr($buffer,0,(index($buffer,'}')+1),'');

	    #canonicalize
	    $body =~ s/\n//g;
	    $body =~ s/\r//g;
	    $body =~ s/\s+/ /g;
	    $body =~ s/'/\\'/g;#' dammit 
	    $body =~ s/ *: */ : /g;
	    $body =~ s/ *; */; /g;
	    $body =~ s/^\s+//m;
	    $body =~ s/\s+$//m;

	    # and remove the {}
	    $body =~ s/[}{]//g;

	    foreach my $selector (@selectors) {
		                # unconditionally take selectors like a:hover
		if (defined $selectors_hash->{$selector} or $selector =~ /:/) { 
		    print "Adding body $body for selector $selector\n";
		    $selectors_hash->{$selector} = $body;
		}
	    }
	    undef @selectors;
	    $in_body = 0;
	}
    }
}

sub print_sql_file {
    my $filename = shift;
    my $selectors_hash = shift;

    open my $sql_file, '>', $filename or die "Could not open $filename for write: $!";

    my $selectors = %{$selectors_hash};

    foreach my $selector (keys %selectors) {
	print "Writing sql for selector $selector\n";
	if ($selectors_hash->{$selector}) {
	    print $sql_file "INSERT INTO styles (element, definition, theme, user) VALUES ('$selector', '$selectors_hash->{$selector}', '$opt{'t'}', -1);\n";
	}
    }
    close $sql_file;
}
