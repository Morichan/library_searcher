package lib::Result;

use Mouse;
use CGI;

use lib::ResultContaints;

has q => ( is => "rw" );
has name => ( is => "ro", default => "result" );
has result_containts_list => ( is => "rw" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->result_containts_list([lib::ResultContaints->new]);
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
        $self->make_containts;
    }

    return (
        $self->q->start_div( {-class => "result"} ),
        $self->q->start_form( -method => "POST" ),
        $self->show_result_area,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub show_result_area {
    my $self = shift;

    return $self->q->p(
        $self->q->start_div({-class => "result"}),
        $self->q->textarea(
            -name => $self->name,
            -default => $self->show_containts,
            -rows => 50,
            -columns => 50),
        $self->q->end_div,
        "\n");
}

sub show_containts {
    my $self = shift;

    my @list = ();

    foreach my $content (@{$self->result_containts_list}) {
        push @list, $content->show;
    }

    return @list;
}

sub make_containts {
    my $self = shift;

    foreach my $containt (@{$self->result_containts_list}) {
        $containt->title(lib::Title->new(default => $self->title));
        $containt->author(lib::Author->new(default => $self->author));
        $containt->isbn(lib::ISBN->new(default => $self->isbn));
        $containt->price(lib::Price->new(default => "3,888円"));
        $containt->publisher(lib::Publisher->new(default => $self->publisher));
        $containt->year(lib::Year->new(default => 2018));

        $containt->make_containts;
    }
}

1;
