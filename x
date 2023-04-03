import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

    public static void main(String[] args) throws IOException {
        List<String> filePaths = new ArrayList<>();
        filePaths.add("file1.yml");
        filePaths.add("file2.yml");
        Map<String, List<String>> dataMap = new LinkedHashMap<>();
        for (String filePath : filePaths) {
            File file = new File(filePath);
            if (!file.exists()) {
                System.out.println("File " + filePath + " does not exist.");
                continue;
            }
            FileInputStream inputStream = new FileInputStream(file);
            Yaml yaml = new Yaml();
            Map<String, Object> yamlData = yaml.load(inputStream);
            List<Map<String, Object>> policies = (List<Map<String, Object>>) yamlData.get("items");
            for (Map<String, Object> policy : policies) {
                String policyName = (String) ((Map<String, Object>) policy.get("metadata")).get("name");
                List<String> ports = new ArrayList<>();
                List<Map<String, Object>> egress = (List<Map<String, Object>>) ((Map<String, Object>) policy.get("spec")).get("egress");
                for (Map<String, Object> e : egress) {
                    if (e.containsKey("ports")) {
                        List<Object> portList = (List<Object>) e.get("ports");
                        for (Object port : portList) {
                            if (port instanceof Integer) {
                                ports.add(String.valueOf(port));
                            } else if (port instanceof Map) {
                                Map<String, Object> portMap = (Map<String, Object>) port;
                                String portNumber = String.valueOf(portMap.get("port"));
                                String protocol = (String) portMap.get("protocol");
                                ports.add(protocol + "/" + portNumber);
                            }
                        }
                    }
                }
                if (dataMap.containsKey(policyName)) {
                    dataMap.get(policyName).addAll(ports);
                } else {
                    dataMap.put(policyName, ports);
                }
            }
        }
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Egress Ports");
        int rownum = 0;
        for (String policyName : dataMap.keySet()) {
            Row row = sheet.createRow(rownum++);
            Cell cell0 = row.createCell(0);
            cell0.setCellValue(policyName);
            List<String> ports = dataMap.get(policyName);
            int cellnum = 1;
            for (String port : ports) {
                Cell cell = row.createCell(cellnum++);
                cell.setCellValue(port);
            }
        }
        String fileName = "Egress Ports Report.xlsx";
        workbook.write(new File(fileName).getAbsoluteFile());
        workbook.close();
        System.out.println("Excel report generated: " + fileName);
    }
}

<<<<dependency>
  <groupId>org.apache.poi</groupId>
  <artifactId>poi</artifactId>
  <version>5.1.0</version>
</dependency>
<dependency>
  <groupId>commons-io</groupId>
  <artifactId>commons-io</artifactId>
  <version>2.11.0</version>
</dependency>



<dependency>
  <groupId>org.apache.poi</groupId>
  <artifactId>poi-ooxml</artifactId>
  <version>5.1.0</version>
</dependency>>>>>

