package lib::Result;

use Mouse;
use CGI;

use lib::ResultArea;

has q => ( is => "rw" );
has result_area => ( is => "rw" );
has title => ( is => "rw", default => "" );
has author => ( is => "rw", default => "" );
has isbn => ( is => "rw", default => "" );
has publisher => ( is => "rw", default => "" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->result_area(lib::ResultArea->new);
}

sub has_result {
    my $self = shift;

    return $self->title ne "";
}

sub show {
    my $self = shift;

    if (not @_) {
        return (
            $self->q->start_div( {-class => "result"} ),
            $self->q->start_form( -method => "POST" ),
            $self->result_area->show,
            $self->q->end_form,
            $self->q->end_div,
            "\n\n");
    } else {
        return (
            $self->q->start_div( {-class => "result"} ),
            $self->q->start_form( -method => "POST" ),
            $self->result_area->show(shift),
            $self->q->end_form,
            $self->q->end_div,
            "\n\n");
    }
}

1;
