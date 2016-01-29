package Model::User;

use Model;
@Model::User::ISA=qw(Model);

sub init
{
	my $self=shift;
	$self->{table}="hwReg";
	$self->{orderBy}="insertDate DESC";
}

sub reportSql
{
	my $self=shift;
	return qq[SELECT firstName,lastName,address1,address2,city,state,country,zip,insertDate from $self->{table} ORDER BY $self->{orderBy}];
}


sub saveRow
{
	my $self=shift;
	my $rowData=shift;

	my $sth=$self->{db}->prepare("insert into hwReg (id,firstName,lastName,address1,address2,city,state,country,zip,insertDate) VALUES (null,?,?,?,?,?,?,?,?,NOW())");
	$sth->execute(@$rowData{qw(firstName lastName address1 address2 city state country zip)});
}



1;
