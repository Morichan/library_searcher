package lib::SearchButton;

use utf8;
use Mouse;
use CGI;

has q => ( is => "rw" );
has class_name => ( is => "ro", default => "search_button" );
has name => ( is => "rw", default => "search_button" );
has value => ( is => "rw", default => '検索' );
has click_count => ( is => "rw", default => 0 );
has is_already_shown_default => ( is => "rw", default => 0 );

sub BUILD {
    my $self = shift;
}

sub show {
    my $self = shift;

    return (
        $self->q->start_div({-class => $self->class_name}),
        $self->q->submit($self->name, $self->value),
        $self->q->end_div,
        "\n");
}

sub is_not_yet_clicked {
    my $self = shift;

    return $self->click_count == 0;
}

sub search_library {
    my $self = shift;

    $self->click_count($self->click_count + 1);
}

1;
