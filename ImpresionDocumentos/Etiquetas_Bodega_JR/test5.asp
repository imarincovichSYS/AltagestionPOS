<script type="text/javascript">
function ElementContent(id,content)
{
    document.getElementById(id).value = content;
    }
    </script>
    
    <textarea id="ta1">&nbsp;</textarea>
    <button value="Click Me!" onclick="ElementContent('ta1','Hey, it works.')" 
    />
