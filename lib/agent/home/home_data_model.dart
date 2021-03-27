class MessageData{
  String vendorName, riderName;

  MessageData(this.vendorName, this.riderName);
}

class ReviewDataModelRider{
  String profileImageUrl, vendorBusinessName, rating, reviewText;

  ReviewDataModelRider(this.profileImageUrl, this.vendorBusinessName, this.rating, this.reviewText);
}

class OrderData{
  String package, riderName, pickUpAt, dropOffAdd, price,
      packageDeliveryStatus, packageId;

  OrderData(this.package, this.riderName, this.pickUpAt, this.dropOffAdd,
      this.price, this.packageDeliveryStatus, this.packageId);

}


class VehicleChoice{

final String vehicleType;

const VehicleChoice(this.vehicleType);

}

const List<VehicleChoice> vehicleType = const <VehicleChoice>[
  const VehicleChoice("Bicycle"),
  const VehicleChoice("Motorcycle"),
  const VehicleChoice("Tricycle"),
  const VehicleChoice("Car"),
  const VehicleChoice("Bus"),
  const VehicleChoice("Truck"),

];



class MyRiderList{
  String riderId, riderMail, riderName, profileImage;

  MyRiderList(
      this.riderId,
      this.riderMail,
      this.riderName,
      this.profileImage
      );
}