// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AutoLoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoLoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutoLoginState()';
}


}

/// @nodoc
class $AutoLoginStateCopyWith<$Res>  {
$AutoLoginStateCopyWith(AutoLoginState _, $Res Function(AutoLoginState) __);
}


/// Adds pattern-matching-related methods to [AutoLoginState].
extension AutoLoginStatePatterns on AutoLoginState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Authenticated value)?  authenticated,TResult Function( UnAuthenticated value)?  unAuthenticated,TResult Function( Guest value)?  guest,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case UnAuthenticated() when unAuthenticated != null:
return unAuthenticated(_that);case Guest() when guest != null:
return guest(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Authenticated value)  authenticated,required TResult Function( UnAuthenticated value)  unAuthenticated,required TResult Function( Guest value)  guest,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case Loading():
return loading(_that);case Authenticated():
return authenticated(_that);case UnAuthenticated():
return unAuthenticated(_that);case Guest():
return guest(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Authenticated value)?  authenticated,TResult? Function( UnAuthenticated value)?  unAuthenticated,TResult? Function( Guest value)?  guest,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case UnAuthenticated() when unAuthenticated != null:
return unAuthenticated(_that);case Guest() when guest != null:
return guest(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  authenticated,TResult Function()?  unAuthenticated,TResult Function()?  guest,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Authenticated() when authenticated != null:
return authenticated();case UnAuthenticated() when unAuthenticated != null:
return unAuthenticated();case Guest() when guest != null:
return guest();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  authenticated,required TResult Function()  unAuthenticated,required TResult Function()  guest,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case Loading():
return loading();case Authenticated():
return authenticated();case UnAuthenticated():
return unAuthenticated();case Guest():
return guest();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  authenticated,TResult? Function()?  unAuthenticated,TResult? Function()?  guest,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Authenticated() when authenticated != null:
return authenticated();case UnAuthenticated() when unAuthenticated != null:
return unAuthenticated();case Guest() when guest != null:
return guest();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AutoLoginState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutoLoginState.initial()';
}


}




/// @nodoc


class Loading implements AutoLoginState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutoLoginState.loading()';
}


}




/// @nodoc


class Authenticated implements AutoLoginState {
  const Authenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutoLoginState.authenticated()';
}


}




/// @nodoc


class UnAuthenticated implements AutoLoginState {
  const UnAuthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnAuthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutoLoginState.unAuthenticated()';
}


}




/// @nodoc


class Guest implements AutoLoginState {
  const Guest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Guest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutoLoginState.guest()';
}


}




// dart format on
