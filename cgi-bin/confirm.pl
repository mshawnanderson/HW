#!/usr/bin/perl
use strict;

use CGI qw(header);
use HTML::Template;

my $cgi=new CGI;

main();

sub main
{
 	my $page=HTML::Template->new(filename=>"templates/confirmReg.tmpl");
	print $cgi->header;
 	print $page->output;
	exit;
	
}


