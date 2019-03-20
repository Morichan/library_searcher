package lib::ResultArea;

use Mouse;
use CGI;

has q => ( is => "rw" );
has name => ( is => "ro", default => "result" );
has containts => ( is => "rw", default => "ここに結果を出力します。\n\nタイトル:\n著者:\nISBN:\n価格:\n出版社:\n出版年:\n\n全ての項目を埋める必要はありません。" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
}

sub show {
    my $self = shift;

    if (@_) {
        $self->containts(shift);
    }
    return $self->q->p(
        $self->q->start_div({-class => "result"}),
        $self->q->textarea(
            -name => $self->name,
            -default => $self->containts,
            -rows => 50,
            -columns => 50),
        $self->q->end_div,
        "\n");
}

1;
