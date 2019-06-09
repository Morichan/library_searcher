package lib::Param;

use utf8;
use Mouse;

has q => ( is => "rw", isa => "CGI" );
has class_name => ( is => "ro", default => "library_param" );
has title => ( is => "rw", default => "____" );
has name => ( is => "rw", default => "____" );
has value => ( is => "rw", default => "default" );
# https://pointoht.ti-da.net/e6782591.html より
has maxlength => ( is => "rw", default => 524288);

sub BUILD {
    my $self = shift;

    $self->value(shift) if @_;
}

sub show {
    my $self = shift;

    return (
        $self->q->start_div( { -class => $self->class_name } ),
        $self->q->p($self->title . ":"),
        $self->q->p($self->q->textfield(
                -name => $self->name,
                -value => $self->value,
                -size => 50,
                -maxlength => $self->maxlength)),
        $self->q->end_div,
        "\n");
}

sub print_text {
    my $self = shift;

    $self->title . ": " . $self->value;
}

1;
