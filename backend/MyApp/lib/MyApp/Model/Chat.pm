package MyApp::Model::Chat;
use uni::perl   qw|:dumper|;
use JSON::XS    qw| decode_json encode_json |;
use LWP::UserAgent;

sub send_to_telegram {
    my ( $self, $params ) = @_;

    my $formdata = {
        chat_id => $params->{chat_id},
        text => $params->{message},
    };

    my $uri = URI->new($params->{url} . '/sendMessage');
    $uri->query_form($formdata);

    my $ua = LWP::UserAgent->new();
    my $response = $ua->get( $uri );

    warn '['.__PACKAGE__."] Send [$uri]";

    my $res_hash = eval { decode_json( $response->decoded_content ) };
    if ( $@ || !$res_hash->{ok} eq 'true' ){
        warn sprintf("Can't send data to telegram: url = '%s': $@. Response - ", $uri, $response->decoded_content);
        return undef;
    }
    return $res_hash;
}

1;