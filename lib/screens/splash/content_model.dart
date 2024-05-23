class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Commercial / Industrial Property',
    image: 'assets/images/smat_propertiesIn.png',
    discription: "Our integrated solution offers key features that facilitate easy management of commercial properties, addressing the unique needs of the commercial industry."
  ),
  UnbordingContent(
    title: 'Student Accommodation',
    image: 'assets/images/smat_studentsPr.png',
    discription: "Manage multi-occupant leasing through tenant communication access, and streamline requests, inspections, work orders, and reporting across stakeholders."
  ),
  UnbordingContent(
    title: 'Storage Units',
    image: 'assets/images/smatpro_storage.png',
    discription: "Streamline workflows with centralized communications, unit type tracking, amenity management, and discounts, while maintaining inventory and staff."
  ),
];
