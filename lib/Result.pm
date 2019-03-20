package lib::Result;

use Mouse;
use CGI;

use lib::ResultContaints;

has q => ( is => "rw" );
has result_containts => ( is => "rw" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->result_containts(lib::ResultContaints->new);
}

sub has_result {
    my $self = shift;

    return $self->title ne "";
}

sub set_containts {
    my $self = shift;

    $self->title(shift);
}

sub show {
    my $self = shift;

    if ($self->has_result) {
        $self->result_containts->has_searched(1);
    }

    return (
        $self->q->start_div( {-class => "result"} ),
        $self->q->start_form( -method => "POST" ),
        $self->result_containts->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub make_containts {
    my $self = shift;

    $self->result_containts->title(lib::Title->new(default => $self->title));
    $self->result_containts->author(lib::Author->new(default => $self->author));
    $self->result_containts->isbn(lib::ISBN->new(default => $self->isbn));
    $self->result_containts->price(lib::Price->new(default => "3,888円"));
    $self->result_containts->publisher(lib::Publisher->new(default => $self->publisher));
    $self->result_containts->year(lib::Year->new(default => 2018));
}

1;
