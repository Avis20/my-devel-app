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
    my @res = qx{ps aux};
    my $str = join ' ', @res;
    $str =~ s/\n/<br>/g;
    $c->response->body($str);
}

sub excel :Chained('') :PathPart('excel') :Args(0) {
    my ( $self, $c ) = @_;

    my $str = '<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
        </head>
        <body>
            <h2>hello</h2>
    ';

    $str .= '<form action="/action">
  <label for="cars">Choose a car:</label>
  <select id="cars" name="cars">
    <option value="volvo">Volvo</option>
    <option value="saab">Saab</option>
    <option value="fiat">Fiat</option>
    <option value="audi">Audi</option>
  </select>
  <input type="submit">
</form>
    ';

    $str .= '</body></html>';

    $c->response->body($str);
}

sub test :Chained('') :PathPart('test') :Args(0) {
    my ( $self, $c ) = @_;
    my @res = qx{ls -l /usr/sbin/cron};
    warn "\n\n";
    warn dumper \@res;
    warn "\n\n";

    my @res = qx{ls -l /var/run /run};
    warn "\n\n";
    warn dumper \@res;
    warn "\n\n";

    my @res = qx{ls -l /etc/cron.d/crontab};
    warn "\n\n";
    warn dumper \@res;
    warn "\n\n";
    
    my @res = qx{cron};
    warn "\n\n";
    warn dumper \@res;
    warn "\n\n";
    my @res = qx{ps aux};
    my $str = join ' ', @res;
    $str =~ s/\n/<br>/g;
    $c->response->body($str);
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub test_curl :Chained('') :PathPart('curl/test') :Args(0) {
    my ( $self, $c ) = @_;
    my $url = $c->req->param('url');
    my @res = qx{curl -I $url};
    my $str = join ' ', @res;
    $str =~ s/\n/<br>/g;
    $c->response->body($str);
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

# todo
=head
sub set_tg_webhook :Chained('') :PathPart('send/telegram') :Args(0) {
    my ( $self, $c ) = @_;

    my $telegram_conf = $c->config->{Telegram};
    my $url = $telegram_conf->{protocol} . '://' . $telegram_conf->{host} . '/bot' . $telegram_conf->{token};
    my $res = MyApp::Model::Chat->send_to_telegram({ url => $url, chat_id => $chat_id, message => $msg });
    $c->res->body( decode('utf8', encode_json( $res || {} ) ) );
}
=cut

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
