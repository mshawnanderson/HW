#!/usr/bin/perl
use strict;

use CGI qw(header);
use HTML::Template;
use Model::User;


main();

sub main
{
	my $cgi=new CGI;

 	my $page=HTML::Template->new(filename=>"templates/report.tmpl");
	my @headers=("First Name","Last Name","Address 1","Address 2", "City", "State", "Zip", "Country", "Insert Date");

	my @headerData;
	# Get Headers
	foreach (@headers)
	{
		my %reportHeader;
		$reportHeader{NAME}=$_;
		push (@headerData, \%reportHeader);
	}
	$page->param(HEADERS=>\@headerData);

	my $User=Model::User->new();
	my $r=$User->report();

	my @reportData;
	my $rowCount=0;
	foreach (@$r)
	{
		$rowCount++;
		my @rowData;
		for (my $i=0;$i<=$#headers;$i++)
		{
			my %field;
			$field{VALUE}=$$_[$i];
			push (@rowData, \%field);	
		}
		my $rowClass=$rowCount%2 ? "odd":"even";
		push (@reportData,{ROWDATA=>\@rowData,CLASS => $rowClass});
		
	}
	$page->param(REPORTDATA=>\@reportData);

	print $cgi->header;
 	print $page->output;
	exit;
	
}

