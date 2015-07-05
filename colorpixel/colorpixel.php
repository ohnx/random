<?php
function html2rgb($color) {
	//Remove starting #
	if ($color[0] == '#') $color = substr($color, 1);
	
	//check if 6, 3 or otherwise invalid color
	if (strlen($color) == 6)
		list($r, $g, $b) = array($color[0].$color[1], $color[2].$color[3], $color[4].$color[5]);
	elseif (strlen($color) == 3)
		list($r, $g, $b) = array($color[0].$color[0], $color[1].$color[1], $color[2].$color[2]);
	else
		return array(0, 0, 0); //return black if invalid

	$r = hexdec($r);
	$g = hexdec($g);
	$b = hexdec($b);

	return array($r, $g, $b);
}
if(isset($_GET['hex'])) {
	$hex = $_GET['hex'];
	$im = imagecreatetruecolor(1, 1)
		or die('Oops, an error occured.');

	//convert RGB to hex
	$rgb = html2rgb($hex);
	$color = imagecolorallocate($im, $rgb[0], $rgb[1], $rgb[2]); 
	imagesetpixel($im, 0, 0, $color);

	//send image
	header('Content-Type: image/png');
	imagepng($im);
	imagedestroy($im);
} else {
//display color picking page
?>
<script type="text/javascript" src="jscolor/jscolor.js"></script>
<h1>Color not specified.</h1>
<h2>Please specify color below:</h2>
<form name="input" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="get">
Hexdecimal color: <input class="color" name="hex">
<input type="submit" value="Submit">
</form>
<?php } ?>
