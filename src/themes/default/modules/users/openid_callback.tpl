<!-- BEGIN: main -->
<script type="text/javascript">
$(document).ready(function() {
    const messageData = {
        type: 'oauthLoginCallback',
        redirect: '{OPIDRESULT.redirect}',
        result: '{OPIDRESULT.status}',
        message: `{OPIDRESULT.mess}<!-- BEGIN: success --><span class="load-bar"></span><!-- END: success -->`,
        statusClass: 'nv-info {OPIDRESULT.status}'
    };
    if (window.opener && !window.opener.closed) {
        window.opener.postMessage(messageData, '{NV_MY_DOMAIN}');
        window.close();
    } else {
        window.location.href = '{OPIDRESULT.redirect}';
    }
});
</script>
<!-- END: main -->
