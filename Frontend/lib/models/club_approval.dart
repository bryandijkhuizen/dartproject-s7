class ClubApproval{
  String name;
  String email;
  String note;
  int clubID;

  ClubApproval(this.name, this.email, this.note, this.clubID);

  ClubApproval.fromJson(Map<String, dynamic> dataMap)
      : name = dataMap['name'],
        email = dataMap['email_address'],
        note = dataMap['note'],
        clubID = dataMap['id'];  
}