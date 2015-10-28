use v6;

role Attribute::SetOnce::IsSet {}

role Attribute::SetOnce {
    method compose($pkg) {
        callsame;
        $pkg.^find_method(self.name.substr(2)).wrap(-> $obj {
            Proxy.new(
                FETCH => -> $ { self.get_value($obj) },
                STORE => -> $, $v {
                    my $value = self.get_value($obj);
                    die "Cannot re-set a set-once attribute"
                      if $value.defined
                      || $value.does(Attribute::SetOnce::IsSet);
                    self.set_value($obj,$v);
                }
            );
        });
   }
}

multi sub trait_mod:<is>(Attribute:D $attr, :$set-once!) is export {
    $attr does Attribute::SetOnce;
    $attr.set_rw();
    warn "useless use of 'is set-once' on $attr.name()"
      unless $attr.has_accessor;
}

# vim:ft=perl6
