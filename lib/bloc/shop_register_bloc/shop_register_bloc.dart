import 'package:bloc/bloc.dart';
import 'package:vilmart_android/bloc/form_bloc/form_submission_status.dart';
import 'package:vilmart_android/bloc/shop_register_bloc/shop_register_event.dart';
import 'package:vilmart_android/bloc/shop_register_bloc/shop_register_state.dart';
import 'package:vilmart_android/data/model/add_store_model/add_store_model.dart';
import 'package:vilmart_android/data/services/add_store_service.dart';

import '../../data/repositories/store_add_repository.dart';


class ShopRegisterBloc extends Bloc<ShopRegisterEvent, ShopRegisterState> {
  ShopRegisterBloc() : super(ShopRegisterState()) {
    on<ShopRegisterEvent>((event, emit) {
      onMapEventToState(event,emit);
    });
  }

  Future<void> onMapEventToState(ShopRegisterEvent event, Emitter<ShopRegisterState> emit) async {
    if(event is onCategoryChange){
      emit(state.copyWith(
        categoryIndex: event.index,
          category:event.category,
          formStatus: FormEditing()
      ));
    }
    if(event is onShopNameChange){
      emit(state.copyWith(
        shopName:event.shopName,
        isShopName:event.shopName.isNotEmpty,
        formStatus: FormEditing()
      ));
    }
    if(event is onShopOwnerChange){
      emit(state.copyWith(
          ownerName:event.ownerName,
          isOwnerName:event.ownerName.isNotEmpty,
          formStatus: FormEditing()
      ));
    }
    if(event is onShopPhoneChange){
      emit(state.copyWith(
          phone:event.phone,
          isPhone:RegExp(r'^\d{10}$').hasMatch(event.phone),
          formStatus: FormEditing()
      ));
    }
    if(event is onShopEmailChange){
      emit(state.copyWith(
          email:event.email,
          isEmail:RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email),
          formStatus: FormEditing()
      ));
    }
    if(event is onShopLocationChange){
      emit(state.copyWith(
          latitude:event.latitude,
          longitude:event.longitude,
          formStatus: FormEditing()
      ));

    }
    if(event is onShopAddressChange){
      emit(state.copyWith(
          address:event.address,
          isAddress:event.address.isNotEmpty,
          formStatus: FormEditing()
      ));
    }
    if(event is onShopCityChange){
      emit(state.copyWith(
          address:event.city,
          isAddress:event.city.isNotEmpty,
          formStatus: FormEditing()
      ));
    }
    if(event is onShopStateChange){
      emit(state.copyWith(
          address:event.state,
          isAddress:event.state.isNotEmpty,
          formStatus: FormEditing()
      ));
    }
    if(event is onShopCountryChange){
      emit(state.copyWith(
          address:event.country,
          isAddress:event.country.isNotEmpty,
          formStatus: FormEditing()
      ));
    }
    if(event is onShopPincodeChange){
      emit(state.copyWith(
          pincode:event.pincode,
          isPincode:RegExp(r'^\d{6}$').hasMatch(event.pincode),
          formStatus: FormEditing()
      ));
    }
    if(event is onShopGstChange){
      emit(state.copyWith(
          gst:event.gst,
          isGst:RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(event.gst),
          formStatus: FormEditing()
      ));
    }
    if(event is onSubmitButtonCLicked){
      print("clicked");
      final isValid = state.isShopName && state.isOwnerName && state.isPhone && state.isEmail && state.isAddress && state.isPincode;

      // Emit submission in progress status
      emit(state.copyWith(formStatus: FormSubmitting()));

      if (isValid) {
        final storeAddress = AddressModel(
          address: state.address,
          city: state.city,
          state: state.state,
          country: state.country,
          pincode: state.pincode,
        );
        final storeLocation = LatLonModel(
          latitude: state.latitude,
          longitude: state.longitude,
        );
        final storeData = AddStoreModel(
          category: state.category,
          shopName: state.shopName,
          ownerName: state.ownerName,
          phone: state.phone,
          email: state.email,
          latlon: storeLocation,
          address: storeAddress,
          gst: state.gst,
        );


        final storeAddRepository = StoreAddRepository();

        try {
          // Add the store to Firestore
          final response = await storeAddRepository.addStore(storeData);
          print(response);

          // Emit success state
          emit(state.copyWith(formStatus: SubmissionSuccess(message:response)));
        } catch (e) {

        }
      } else {
        // Emit failure state if the form is not valid
        emit(state.copyWith(formStatus: SubmissionFailed('Invalid form')));
      }
    }

  }

}
