#!/usr/bin/perl
use strict;

use CGI;
use DBI;

use HTML::Entities;
use HTML::Template;

use Model::User;

my @fields=qw(firstName lastName address1 city state zip country);
my $cgi=new CGI;

main();

sub main
{

	my $output;
	if ($cgi->param('Submit') eq "Register")
	{
		procForm(\$output);
	}
	else
	{
		makeForm(\$output);
	}

	print $cgi->header;
	print $output;
	exit 0;
}


sub procForm
{
	my $outRef=shift;

	my @badVals;
	my @msg;

	#custom validations
	my %pats=(
		country=>[qr/^US$/],
		zip=>[qr/^\d{5}$/,qr/^\d{9}$/]
	);

	my %vals=map{($_=>scalar $cgi->param($_))}@fields;
	

	while (my ($k,$v)=each %vals)
	{
		# any value
		if ($v eq "")
		{
			push (@badVals,$k);
		}

		# custom values
		if (exists($pats{$k}))
		{
			my $patMatch = 0;
			foreach (@{$pats{$k}})
			{	
				if ($v =~ /$_/)
				{
					$patMatch=1;
					last;
				}
			}
			push (@badVals,$k) unless $patMatch;
		}
	}
	
	#remap vals, but handle encoding
	%vals=map{$_=>HTML::Entities::encode(scalar $cgi->param($_))}@fields;

	if (scalar (@badVals))
	{
		foreach (@badVals)
		{
			push (@msg, $cgi->param($_) ? "Incorrect Format for $_." : "Value Missing for $_");
		}
		makeForm($outRef,\%vals, \@msg);		
	}

	# still here?  Save and Confirm
	my $User = Model::User->new();
	$User->saveRow(\%vals);
	
	print $cgi->redirect(-location=>"/cgi-bin/confirm.pl");
	
}

sub makeForm
{
	my ($resRef,$valsRef,$msgRef)=@_;
 	my $form=HTML::Template->new(filename=>"templates/registerForm.tmpl");


	if ((defined($valsRef)) && (ref($valsRef) eq "HASH") && (scalar(keys %$valsRef)))
	{
		# If we got values reset - then the form has been submitted
		# if the form has been submitted, and we're here -- then there were errors.
		$form->param(MSGBODY=>join("<BR>",@$msgRef));	
	}  

	# set the values -- if we dont' have any, it's quite okay to leave them undef

	$form->param(FIRSTNAME=>$$valsRef{firstName});
	$form->param(LASTNAME=>$$valsRef{lastName});
	$form->param(ADDRESS1=>$$valsRef{address1});
	$form->param(ADDRESS2=>$$valsRef{address2});
	$form->param(CITY=>$$valsRef{city});
	$form->param(STATE=>$$valsRef{state});
	$form->param(ZIP=>$$valsRef{zip});
	$form->param(COUNTRY=>$$valsRef{country});

	print $cgi->header;
 	print $form->output;
	exit;
	
}


