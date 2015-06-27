Title: PHP短URL函数
Date: 2012-04-22 22:39:11
Tags: PHP, 短网址


分享一个shortUrl的函数 
    
    
    function shorturl($input) {
    
      $base62 = array (
    
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    
        'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    
        'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    
        'y', 'z', 'A','B','C','D','E','F','G',
    
        'H','I','J','K','L','M','N','O','P',
    
        'Q','R','S','T','U','V','W','X','Y',
    
        'Z','0', '1', '2', '3', '4', '5','6','7','8','9'
    
        );
    
      $hex = md5($input);
    
      $hexLen = strlen($hex);
    
      $subHexLen = $hexLen / 8;
    
      $output = array();
    
      for ($i = 0; $i < $subHexLen; $i++) {
    
        $subHex = substr ($hex, $i * 8, 8);
    
        $int = 0x3FFFFFFF & (1 * ('0x'.$subHex));
    
        $out = '';
    
        for ($j = 0; $j < 6; $j++) {
    
          $val = 0x0000003D & $int;
    
          $out .= $base62[$val];
    
          $int = $int >> 5;
    
        }
    
        $output[] = $out;
    
      }
    
      return $output;
    
    }
    
    $ret= shorturl('http://www.google.com');
    
    print_r($ret);
