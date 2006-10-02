#!/usr/bin/perl -w
while (<>) {
	chomp; 
	(undef,$t,$time) = split(/\s+/); 
	$time =~ s/\((.*)\)/$1/; 
	$q{$t} += $time; 
	$max{$t} = $time unless defined $max{$t} and $max{$t} > $time;
	$min{$t} = $time unless defined $min{$t} and $min{$t} < $time;
	#print "### $time $t ###\n" if $time > 1; 
	$i++;
} 

print "-"x17, " $i ", "-"x17, "\n"; 

foreach my $e (sort { $max{$a} <=> $max{$b} } keys %q) { 

	$avg = $q{$e} / $i;
	
#	next unless $avg > .0001;

	print "$q{$e} ($avg) $max{$e} $min{$e} $e\n";
	$total += $q{$e}; 
} 

print "-"x40, "\n"; 
print "-"x8," Total: $total ", "-"x7, "\n"; 
