mixin ValidationMixinClass{
  String? combine(List<String? Function()> validators){
    for (final func in validators){
      final validations = func();
      if(validations != null) return validations;
    }
    return null;
  }

  String? isNotEmpyt(String? value, [String? message]){
    if(value!.isEmpty) return message ?? "Campo em Branco!";
    return null;
  }

  String? hasSixChars(String? value, [String? message]){
    if(value!.length < 6) return message ?? "Você tem que usar 6 caracteres!";
    return null;
  }
}