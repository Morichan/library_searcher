package Param;

use Mouse;
use CGI;

has q => ( is => "rw" );
has text => ( is => "rw" );

sub create {
    my $self = shift;
    $self->q(CGI->new);

    print $self->q->start_form( -method => "POST" );
    print $self->q->p($self->q->textfield(-name => "field",
            -default => "starting values",
            -override => 1,
            -size => 50,
            -maxlength => 20));
    print $self->q->end_form;
}

1;
