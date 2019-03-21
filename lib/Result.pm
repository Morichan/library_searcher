package lib::Result;

use utf8;
use Mouse;
use CGI;

use lib::ResultContaints;
use lib::SearchEngine;

has q => ( is => "rw" );
has name => ( is => "ro", default => "result" );
has result_containts_list => ( is => "rw" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );
has search_engine => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->search_engine(lib::SearchEngine->new);
    $self->result_containts_list([lib::ResultContaints->new]);
}

sub has_input {
    my $self = shift;

    return not (
        $self->title eq "" and
        $self->author eq "" and
        $self->isbn eq "" and
        $self->publisher eq ""
    );
}

sub set_containts {
    my $self = shift;

    $self->title(shift);
}

sub show {
    my $self = shift;

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
            -default => $self->show_containts_list,
            -rows => 50,
            -columns => 50),
        $self->q->end_div,
        "\n");
}

sub show_containts_list {
    my $self = shift;

    my @list = ();
    my $is_first = 1;

    if (not @{$self->result_containts_list}) {
        return "No containts";
    }

    foreach my $contents (@{$self->result_containts_list}) {
        push @list, $contents->show;
    }

    return join("\n\n", @list);
}

sub make_containts_list {
    my $self = shift;

    $self->search_engine->explorer($self->title, $self->author, $self->isbn, $self->publisher);

    $self->result_containts_list($self->search_engine->results);
}

1;
