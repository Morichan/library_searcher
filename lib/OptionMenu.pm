package lib::OptionMenu;

use utf8;
use Mouse;

has q => ( is => "rw" );

sub show {
    my $self = shift;

    return (
        $self->q->start_div( { -class => "hidden_menu" } ),
        $self->q->label( { -for => "hidden_menu_label" }, "詳細設定"),
        $self->q->input( { -type => "checkbox", -id => "hidden_menu_label" } ),
        $self->q->start_div( { -class => "hidden_show" }),
        "MenuItem",
        $self->q->end_div,
        $self->q->end_div
    );
}

1;
