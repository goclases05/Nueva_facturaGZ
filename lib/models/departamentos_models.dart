import 'dart:convert';

Departamentos departamentosFromJson(String str) => Departamentos.fromJson(json.decode(str));

String departamentosToJson(Departamentos data) => json.encode(data.toJson());

class Departamentos {
    Departamentos({
        required this.totalDepa,
        required this.departamentos,
    });

    String totalDepa;
    List<Departamento> departamentos;

    factory Departamentos.fromJson(Map<String, dynamic> json) => Departamentos(
        totalDepa: json["total_depa"],
        departamentos: List<Departamento>.from(json["departamentos"].map((x) => Departamento.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_depa": totalDepa,
        "departamentos": List<dynamic>.from(departamentos.map((x) => x.toJson())),
    };
}

class Departamento {
    Departamento({
        required this.id,
        required this.departamento,
        required this.departamentoCorto,
        required this.icono,
    });

    String id;
    String departamento;
    String departamentoCorto;
    String icono;

    factory Departamento.fromJson(Map<String, dynamic> json) => Departamento(
        id: json["ID"],
        departamento: json["DEPARTAMENTO"],
        departamentoCorto: json["DEPARTAMENTO_CORTO"],
        icono: json["ICONO"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "DEPARTAMENTO": departamento,
        "DEPARTAMENTO_CORTO": departamentoCorto,
        "ICONO": icono,
    };
}
