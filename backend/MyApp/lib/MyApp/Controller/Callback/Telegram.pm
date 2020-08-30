package MyApp::Controller::Callback::Telegram;
use Moose;
use namespace::autoclean;

use uni::perl       qw| :dumper |;
use Encode          qw| encode decode |;
use JSON::XS        qw| decode_json encode_json |;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => 'callback');

sub webhook : Chained('base') : PathPart('webhook') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{json_data} = { success => 0 };
    return unless ref $c->req->body;
    open my $fh, $c->req->body->filename;
    my $json = join('', map { chomp; encode('UTF-8',$_) } <$fh> ) || '{}';
    warn "\n\n";
    warn "json = $json";
    warn "\n\n";
    my $body = decode_json( $json );
    close $fh;

    my $chat_id = $c->req->param('chat_id') || $c->config->{Telegram}->{chat_id};
    my $telegram_conf = $c->config->{Telegram};
    my $url = $telegram_conf->{protocol} . '://' . $telegram_conf->{host} . '/bot' . $telegram_conf->{token};

    my $msg = $body->{message}->{text} || 'something wrong';
    if ( $body->{message}->{text} eq '/tail' ) {
        my @res = qx{tail -13 /var/log/ping-ya.ru.log};
        $msg = join ' ', @res;
    }

    my $res = MyApp::Model::Chat->send_to_telegram({ url => $url, chat_id => $chat_id, message => $msg });
    $c->res->body( decode('utf8', encode_json( $res || {} ) ) );
}

__PACKAGE__->meta->make_immutable;

1;
