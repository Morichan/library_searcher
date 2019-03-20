package lib::Param;

use Mouse;
use CGI;

has q => ( is => "rw" );
has title => ( is => "rw", default => "____" );
has name => ( is => "rw", default => "____" );
has default => ( is => "rw", default => "default" );
# https://pointoht.ti-da.net/e6782591.html より
has maxlength => ( is => "rw", default => 524288);

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->default(shift) if @_;
}

sub show {
    my $self = shift;

    return (
        $self->q->start_div({-class => "textfield"}),
        $self->q->p($self->title . ":"),
        $self->q->p($self->q->textfield(
                -name => $self->name,
                -default => $self->default,
                -size => 50,
                -maxlength => $self->maxlength)),
        $self->q->end_div,
        "\n");
}

sub print_text {
    my $self = shift;

    $self->title . ": " . $self->default;
}

1;
