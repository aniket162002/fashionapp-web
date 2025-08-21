@extends('backend.layouts.app')

@section('title', 'WhatsApp OTP Templates')

@section('content')
<div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">WhatsApp OTP Templates</h5>
                <div class="pull-right">
                    <a href="{{ route('whatsapp_otp.templates.create') }}" class="btn btn-primary">
                        <i class="las la-plus"></i>
                        Add New Template
                    </a>
                </div>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Template</th>
                            <th>Status</th>
                            <th>Options</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($templates as $key => $template)
                            <tr>
                                <td>{{ $key+1 }}</td>
                                <td>{{ $template->name }}</td>
                                <td>{{ Str::limit($template->template, 50) }}</td>
                                <td>
                                    <label class="aiz-switch aiz-switch-success mb-0">
                                        <input type="checkbox" onchange="updateStatus(this)" value="{{ $template->id }}" @if($template->status) checked @endif>
                                        <span class="slider round"></span>
                                    </label>
                                </td>
                                <td>
                                    <a class="btn btn-soft-primary btn-icon btn-circle btn-sm" href="{{ route('whatsapp_otp.templates.edit', $template->id) }}" title="Edit">
                                        <i class="las la-edit"></i>
                                    </a>
                                    <a href="#" class="btn btn-soft-danger btn-icon btn-circle btn-sm confirm-delete" data-href="{{ route('whatsapp_otp.templates.destroy', $template->id) }}" title="Delete">
                                        <i class="las la-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection

@section('modal')
    @include('modals.delete_modal')
@endsection

@section('script')
<script type="text/javascript">
    function updateStatus(el){
        var status = 0;
        if(el.checked){
            var status = 1;
        }
        $.post('{{ route('whatsapp_otp.templates.status') }}', {_token:'{{ csrf_token() }}', id:el.value, status:status}, function(data){
            if(data == 1){
                AIZ.plugins.notify('success', 'Status updated successfully');
            }
            else{
                AIZ.plugins.notify('danger', 'Something went wrong');
            }
        });
    }
</script>
@endsection 