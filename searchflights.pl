#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my ($o_origin, $d_dest);
my $flag;
my %resultant;

Getopt::Long::Configure("no_ignore_case");
GetOptions(
'o=s'	=> \$o_origin,
'd=s'	=> \$d_dest
) or die "Usage: $0 -o {Origin} -d {Destination}";

if ( !defined $o_origin || !defined $d_dest ) 
{
	printf("Please pass all mandatory arguments\n");
	printf("Args:\n-o - Origin, mandatory\n");
	printf("-d - Destination, mandatory\n");
	printf("Usage: $0 -o {Origin} -d {Destination}");
	exit(1);
}

my $providers = "/Users/annu/Project/provider/Provider*";

open(logon_file, "/bin/ls $providers 2>/dev/null |" ) or die "Could not open file '$providers' $!";

while ($providers = <logon_file> )
{
	my $output;
	chomp($providers);
	open(my $prov, $providers);
	while ( $output = <$prov> ) {
	if ( $output =~ /^$o_origin/ ) 
	{
		my @values = split /[,|]+/,$output;
		my ($orin, $o_date, $dest, $d_date, $price)=($values[0], $values[1], $values[2], $values[3], $values[4]);
		if ($dest eq $d_dest ){
		$resultant{$price}=[ $orin, $o_date, $dest, $d_date, $price ];
		$flag=0;
	}
	}
	}
close($prov);
}

if (! defined($flag))
{
printf("No Flights Found for ".$o_origin." --> ".$d_dest."\n");
}
else 
{
foreach my $key(sort (keys %resultant)) {
printf  ($resultant{$key}[0]." --> ".$resultant{$key}[2]." (".$resultant{$key}[1]." --> ".$resultant{$key}[3].") - ".$resultant{$key}[4])
}
}
close(logon_file);
