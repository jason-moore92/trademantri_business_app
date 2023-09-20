// import 'package:trapp/src/helpers/ip_util.dart';

// class IPAddress {
//   String? ip;
//   int? ipAsInt;
//   List<int> blocks = List.generate(4, (index) => 0);

//   IPAddress.fromSubnetMask(int snm) {
//     if (snm < 1 || snm > 31) {
//       throw FormatException('Subnet part is to small or to big');
//     } else {
//       String s = '';
//       for (int i = 0; i < snm; i++) {
//         s += '1';
//       }
//       s = s.padRight(32, '0');
//       _setFromBin(s);
//     }
//   }

//   IPAddress.fromIP(this.ip) {
//     if (IpUtil.verifyIp(ip!)) {
//       final ipBlocks = ip!.split('.');
//       String asBinary = '';
//       for (int i = 0; i < 4; i++) {
//         blocks[i] = int.parse(ipBlocks[i]);
//         asBinary += blocks[i].toRadixString(2).padLeft(8, '0');
//       }
//       ipAsInt = int.parse(asBinary, radix: 2);
//     } else {
//       throw FormatException('IP Address is in wrong format');
//     }
//   }

//   IPAddress.fromNumber(int ipAsNumber) {
//     if (ipAsNumber > 4294967295) throw FormatException();
//     String ipBinary = ipAsNumber.toRadixString(2).padLeft(32, '0');
//     _setFromBin(ipBinary);
//   }

//   void _setFromBin(String bin) {
//     List<String> b = List.generate(4, (index) => "");
//     b[0] = bin.substring(0, 8);
//     b[1] = bin.substring(8, 16);
//     b[2] = bin.substring(16, 24);
//     b[3] = bin.substring(24, 32);
//     blocks[0] = int.parse(b[0], radix: 2);
//     blocks[1] = int.parse(b[1], radix: 2);
//     blocks[2] = int.parse(b[2], radix: 2);
//     blocks[3] = int.parse(b[3], radix: 2);
//     ipAsInt = int.parse(bin, radix: 2);
//     ip = '${blocks[0]}.${blocks[1]}.${blocks[2]}.${blocks[3]}';
//   }
// }
