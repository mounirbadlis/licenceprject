import 'package:flutter/foundation.dart';

class DoctorProvider extends ChangeNotifier{
  Map ?selectedPatient;
  Map ?selectedRecord;
  Map ?selectedPharmacy;
  Map ?selectedPrescription;
  Map ?selectedComplaint;
}