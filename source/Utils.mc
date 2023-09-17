import Toybox.Lang;


function toViewNumber(value as Number or Null) as String {
    if (value == null) {
        return "-";
    } else {
        return value.toString();
    }
}