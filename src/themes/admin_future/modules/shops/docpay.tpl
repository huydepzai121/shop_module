<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$LANG->getModule('document_payment')}</div>
    <div class="card-body pt-4">
        <form class="form-horizontal" action="" method="post">
            <ul class="nav nav-tabs mb-3" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#payment_docpay" type="button">
                        {$LANG->getModule('document_payment_docpay')}
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#payment_email_order" type="button">
                        {$LANG->getModule('document_payment_email_order')}
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#payment_email_order_payment" type="button">
                        {$LANG->getModule('document_payment_email_order_payment')}
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="payment_docpay">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-hover">
                            <tr>
                                <td class="p-3">
                                    <strong>{$LANG->getModule('setting_intro_pay')}</strong>
                                    <br />
                                    <span class="fst-italic">{$LANG->getModule('document_payment_note')}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>{$CONTENT_DOCPAY}</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="payment_email_order">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <tr>
                                <td>
                                    <strong>{$LANG->getModule('document_payment_email_order_note')}</strong>
                                    <br />
                                    <div class="row docpay">
                                        {foreach from=$ORDER_VARS item=ORDER}
                                        <div class="col-sm-4">
                                            <strong>{{$ORDER.key}}</strong>{$ORDER.value}
                                        </div>
                                        {/foreach}
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>{$CONTENT_ORDER}</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="payment_email_order_payment">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <tr>
                                <td>
                                    <strong>{$LANG->getModule('document_payment_email_order_note')}</strong>
                                    <br />
                                    <div class="row docpay">
                                        {foreach from=$ORDER_VARS item=ORDER}
                                        <div class="col-sm-4">
                                            <strong>{{$ORDER.key}}</strong>{$ORDER.value}
                                        </div>
                                        {/foreach}
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>{$CONTENT_ORDER_PAYMENT}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-save"></i> {$LANG->getModule('save')}
                </button>
                <input type="hidden" value="1" name="saveintro">
            </div>
        </form>
    </div>
</div> 