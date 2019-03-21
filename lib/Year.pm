package lib::Year;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('出版年');
    $self->default('2018');
    $self->name("year");
}

1;
