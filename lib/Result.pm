package lib::Result;

use Mouse;
use CGI;

use lib::ResultArea;

has q => ( is => "rw" );
has result_area => ( is => "rw" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->result_area(lib::ResultArea->new);
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
        $self->result_area->has_searched(1);
    }

    return (
        $self->q->start_div( {-class => "result"} ),
        $self->q->start_form( -method => "POST" ),
        $self->result_area->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub make_containts {
    my $self = shift;

    $self->result_area->title(lib::Title->new(default => $self->title));
    $self->result_area->author(lib::Author->new(default => $self->author));
    $self->result_area->isbn(lib::ISBN->new(default => $self->isbn));
    $self->result_area->price(lib::Price->new(default => "3,888円"));
    $self->result_area->publisher(lib::Publisher->new(default => $self->publisher));
    $self->result_area->year(lib::Year->new(default => 2018));
}

1;
