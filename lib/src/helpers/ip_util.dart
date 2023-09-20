class IpUtil {
  static bool verifyIp(final String ip) {
    // check correct structure
    final ipSplit = ip.split('.');
    if (ipSplit.length != 4) return false;

    // check four blocks are able to be converted to int
    List<int> ipBlocks = List.generate(4, (index) => 0);

    for (int i = 0; i < 4; i++) {
      // check if split string can be converted to int
      try {
        ipBlocks[i] = int.parse(ipSplit[i]);

        // check if block is between 0 and 255
        if (ipBlocks[i] < 0 || ipBlocks[i] > 255) return false;
      } catch (FormatException) {
        return false;
      }
    }
    return true;
  }
}
