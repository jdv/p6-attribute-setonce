use Test;
use Attribute::SetOnce;
use v6;

class A { has $.foo is set-once }
class B { has $.foo is set-once = 789 }

{
    diag("non-type obj attr value after construction");
    my $o = A.new;
    is($o.foo, Any, 'before set');
    $o.foo = 123;
    is($o.foo, 123, 'after 1st set');
    my $e;
    { $o.foo = 456; CATCH { default { $e = $_ } } }
    like(~$e,rx/^Cannot\sre\-set/,'re-set fail');
    is($o.foo, 123, 'after 2nd set');
}

{
    diag("type obj attr value after construction");
    my $o = A.new;
    is($o.foo, Any, 'before set');
    $o.foo = $o.foo but Attribute::SetOnce::IsSet;
    is($o.foo,
      Any but Attribute::SetOnce::IsSet, 'after 1st "set" on type obj');
    my $e;
    { $o.foo = 456; CATCH { default { $e = $_ } } }
    like(~$e,rx/^Cannot\sre\-set/,'re-set fail');
    ok($o.foo ~~ Any:U, 'after 2nd set');
}

{
    diag("non-type obj attr value at construction");
    my $o = A.new(:foo(123));
    is($o.foo, 123, 'after 1st set');
    my $e;
    { $o.foo = 456; CATCH { default { $e = $_ } } }
    like(~$e,rx/^Cannot\sre\-set/,'re-set fail');
    is($o.foo, 123, 'after 2nd set');
}

{
    diag("non-type obj attr value default");
    my $o = B.new;
    my $e;
    is($o.foo, 789, 'before set');
    { $o.foo = 456; CATCH { default { $e = $_ } } }
    like(~$e,rx/^Cannot\sre\-set/,'re-set fail');
    is($o.foo, 789, 'after 2nd set');
}

done-testing;

# vim:ft=perl6
