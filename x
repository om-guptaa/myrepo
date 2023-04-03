 List<Map<String, Object>> portList = (List<Map<String, Object>>) portObj;
    Map<String, Object> portMap = portList.get(0);
    Object portValue = portMap.get("port");
    // Add to HashMap
    HashMap<String, Object> portHashMap = new HashMap<>();
    portHashMap.put("port", portValue);
