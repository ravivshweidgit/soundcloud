# -*- coding: utf-8 -*-
from pathlib import Path
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

out = Path(__file__).with_name("communique.docx")
d = Document()
for sec in d.sections:
    sec.top_margin = Cm(2)
    sec.bottom_margin = Cm(2)
    sec.right_margin = Cm(2.2)
    sec.left_margin = Cm(2.2)

def add(text, size=12, bold=False, space_after=8, color=None):
    p = d.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    p.paragraph_format.space_after = Pt(space_after)
    p.paragraph_format.space_before = Pt(0)
    r = p.add_run(text)
    r.font.name = "David"
    r.font.size = Pt(size)
    r.bold = bold
    r._element.rPr.rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}cs", "David")
    if color:
        r.font.color.rgb = color
    p.paragraph_format.rtl = True
    return p

add("קומוניקט", 11, color=RGBColor(0x66, 0x66, 0x66), space_after=4)
add("רביב שוויד", 22, bold=True, space_after=2)
add("שדות החורף", 18, bold=True, space_after=12)

add("פרטים", 13, bold=True, space_after=4)
for line in [
    "שם השיר: שדות החורף",
    "מבצע: רביב שוויד",
    "מילים: רביב שוויד",
    "לחן: רביב שוויד",
    "זמר: AI",
    "הפקה / אולפן ביתי: רביב שוויד",
    "ייעוץ ספרותי ולשון עברית: נאווה כהן ראקוב",
    "אורך: 4:23",
    "שפה: עברית",
    "הקליפ: https://youtu.be/u-4xvQbypvQ",
]:
    add(line, 12, space_after=2)

add("", 8, space_after=8)
add("על השיר", 13, bold=True, space_after=4)
add(
    "שיר על השבעה באוקטובר. בסוף הקיץ, בשמחת תורה, הבוקר לא עלה בעוטף. "
    "ומאז, בכל חורף, הכלניות מכסות שוב את השדות.",
    space_after=8,
)
add(
    "הקליפ נראה דרך עיניה של תצפיתנית - קודם דרך המסכים, ואחר כך מן השמיים. "
    "אישה אחת מחכה. חורף ועוד חורף, והיא לא מרפה מהיד.",
    space_after=8,
)
add(
    '"שעון החול נפרץ" - מקשר התצפיתניות בבוקר השבעה באוקטובר; '
    '"שעון חול" היה שם הקוד של קטע הגדר. '
    '"לקט, שכחה ופאה" - הנפת דגלים ערכיים: מצוות ערבות הדדית, ביטחון מחיה לחלשים. '
    '"זורעים בדמעה" - תהילים קכו. "מים רבים לא יכבו" - שיר השירים ח, ז.',
    space_after=8,
)
add("לזכר הנרצחים והנופלים, ולזכר החטופים שלא שבו.", space_after=12)

add("קרדיטים", 13, bold=True, space_after=4)
add("מילים: רביב שוויד", space_after=2)
add("לחן: רביב שוויד", space_after=2)
add("זמר: AI", space_after=2)
add("הפקה / אולפן ביתי: רביב שוויד", space_after=2)
add("תסריט הקליפ: רביב שוויד", space_after=2)
add("ייעוץ ספרותי ולשון עברית: נאווה כהן ראקוב", space_after=2)
add(
    "הכתיבה, ההלחנה, התסריט וההפקה הם עבודת אדם באולפן ביתי. הביצוע הקולי נעשה בכלי AI.",
    space_after=12,
)

add("יצירת קשר", 13, bold=True, space_after=4)
add("רביב שוויד", space_after=2)
add("יוטיוב: https://youtu.be/u-4xvQbypvQ", space_after=2)

d.save(out)
print("saved", out.name, out.stat().st_size)
