# trapp
# start date: 2021-11-29

# 7799818016, 9000000001
# trade@123

# 7777700001


##  celekt store: 9052407201, trade@123
##  jockey store: 7799818014, trade@123



https://play.google.com/store/apps/details?id=com.tradilligence.tradeMantriBiz

https://play.google.com/store/apps/details?id=com.tradilligence.tradeMantriBiz

1. Prod build cmd `flutter build appbundle --target lib/main_prod.dart --release --flavor prod`
2. Qa build cmd `flutter build appbundle --target lib/main_qa.dart --release --flavor qa`
3. Checking release in local `flutter run --target lib/main_prod.dart --flavor prod`.
4. Generate freezed entities: `flutter pub run build_runner build`.
5. Start CI/CD pipelines `aws codepipeline start-pipeline-execution --name tmbizapp-qa`







