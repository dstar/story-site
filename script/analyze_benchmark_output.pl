#!/usr/bin/perl -w
while (<>) {
	$i++;
	chomp; 
	(undef,$t,$time) = split(/\s+/); 
	$time =~ s/\((.*)\)/$1/; 
	$q{$t} += $time; 
	
	$count{$t}++;

	unless (defined $max{$t} and $max{$t} > $time) {
		$max{$t} = $time;
		$maxline{$t} = $i;
	}
	unless (defined $min{$t} and $min{$t} < $time) {
		$min{$t} = $time;
		$minline{$t} = $i;
	}
	#print "### $time $t ###\n" if $time > 1; 
} 

print "-"x17, " $i ", "-"x17, "\n"; 

foreach my $e (sort { $q{$a} <=> $q{$b} } keys %q) { 
#foreach my $e (sort { $count{$a} <=> $count{$b} } keys %q) { 

	$avg = $q{$e} / $i;
	
#	next unless $avg > .0001;

	print "$count{$e} $q{$e} ($avg) $max{$e} ($maxline{$e}) $min{$e} ($minline{$e}) $e\n";
	$total += $q{$e}; 
} 

print "-"x40, "\n"; 
print "-"x8," Total: $total ", "-"x7, "\n"; 
