class Employeemodel {
  bool? status;
  List<EmplyeeData>? data;
  String? message;

  Employeemodel({this.status, this.data, this.message});

  Employeemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <EmplyeeData>[];
      json['data'].forEach((v) {
        data!.add(new EmplyeeData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class EmplyeeData {
  int? id;
  String? empId;
  String? empName;
  String? deptCode;
  String? deptName;
  String? image;
  String? color;
  int? status;

  EmplyeeData(
      {this.id,
      this.empId,
      this.empName,
      this.deptCode,
      this.deptName,
      this.image,
      this.color,
      this.status});

  EmplyeeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['empId'];
    empName = json['emp_name'];
    deptCode = json['dept_code'];
    deptName = json['dept_name'];
    image = json['image'];
    color = json['color'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['empId'] = this.empId;
    data['emp_name'] = this.empName;
    data['dept_code'] = this.deptCode;
    data['dept_name'] = this.deptName;
    data['image'] = this.image;
    data['color'] = this.color;
    data['status'] = this.status;

    return data;
  }
}
