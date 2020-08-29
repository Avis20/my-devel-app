package MyApp::Controller::Root;
use Moose;
use namespace::autoclean;
use uni::perl   qw| :dumper |;
use Encode      qw| encode decode |;
use JSON::XS    qw| decode_json encode_json |;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Hello');
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub send_telegram :Chained('') :PathPart('send/telegram') :Args(0) {
    my ( $self, $c ) = @_;
    my $chat_id = $c->req->param('chat_id') || $c->config->{Telegram}->{chat_id};
    my $msg = $c->req->param('msg');
    my $telegram_conf = $c->config->{Telegram};
    my $url = $telegram_conf->{protocol} . '://' . $telegram_conf->{host} . '/bot' . $telegram_conf->{token};
    my $res = MyApp::Model::Chat->send_to_telegram({ url => $url, chat_id => $chat_id, message => $msg });
    $c->res->body( decode('utf8', encode_json( $res || {} ) ) );
}



sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
