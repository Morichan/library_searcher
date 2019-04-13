package lib::ResultContaints;

use utf8;
use Mouse;

use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Price;
use lib::Publisher;
use lib::Year;

has name => ( is => "ro", default => "result" );
has containts => ( is => "rw", default => "" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has price => ( is => "rw" );
has publisher => ( is => "rw" );
has year => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->title(lib::Title->new);
    $self->author(lib::Author->new);
    $self->isbn(lib::ISBN->new);
    $self->price(lib::Price->new);
    $self->publisher(lib::Publisher->new);
    $self->year(lib::Year->new);

    $self->create_default_containts;
}

sub show {
    my $self = shift;

    return $self->containts;
}

sub create_default_containts {
    my $self = shift;

    $self->title->default("");
    $self->author->default("");
    $self->isbn->default("");
    $self->price->default("");
    $self->publisher->default("");
    $self->year->default("");

    $self->containts(
        "ここに結果を出力します。" .
        "\n\n" .
        $self->title->print_text .
        "\n" .
        $self->author->print_text .
        "\n" .
        $self->isbn->print_text .
        "\n" .
        $self->price->print_text .
        "\n" .
        $self->publisher->print_text .
        "\n" .
        $self->year->print_text .
        "\n\n" .
        "全ての項目を埋める必要はありません。"
    );
}

sub make_containts {
    my $self = shift;

    $self->containts(
        $self->title->print_text .
        "\n" .
        $self->author->print_text .
        "\n" .
        $self->isbn->print_text .
        "\n" .
        $self->price->print_text .
        "\n" .
        $self->publisher->print_text .
        "\n" .
        $self->year->print_text .
        "\n"
    );
}

1;
