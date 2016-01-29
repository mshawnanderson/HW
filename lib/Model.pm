package Model;

use DBI;
sub new
{
        my $self={};;
        bless $self,shift;
        $self->dbConnect();
        $self->init();
        return $self;
}

sub dbConnect()
{
        my $self=shift;

        my $pwFile=qq(/usr/local/share/perl5/db.txt);
        open (O, $pwFile) ||  die ("Could not open $pwFile: $!");
        my @p=<O>;
        close O;
        chomp @p;

        $self->{db} = DBI->connect("DBI:mysql:database=$p[0]","$p[1]","$p[2]");
}

sub report
{
	my $self=shift;
	my $sth=$self->{db}->prepare($self->reportSql());
	$sth->execute();
	return $sth->fetchall_arrayref();
}

sub init
{
        return;
}



1;



