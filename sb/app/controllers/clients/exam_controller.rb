class Clients::ExamController < ApplicationController
  def edit
    load_client
    @form = Client::ExamForm.new(nil, @sb_client)
  end

  def edit_approve
    load_client
    @form = Client::ExamApproveForm.new(nil, @sb_client)
  end

  def update
    load_client
    @form = Client::ExamForm.new(client_params, @sb_client)
    @form.current_user = current_internal_user
    @form.to_sb_client

    if @form.other_files_invalid?
      render :edit and return
    end

    if @form.invalid?
      render :edit and return
    end

    @form.save_client
    flash[:success] = "編集が完了しました。"
    redirect_to clients_list_path
  end

  def apply
    load_client
    @form = Client::ExamForm.new(client_params, @sb_client)
    @form.current_user = current_internal_user
    @form.to_sb_client

    if @form.other_files_invalid?
      render :edit and return
    end

    if @form.invalid?
      render :edit and return
    end

    # 稟議申請済みの場合一覧へ戻る
    unless @form.can_apply
      flash[:warning] = "稟議申請済みです。"
      redirect_to clients_list_path and return
    end

    # 決裁テーブル作成
    @form.sb_client_exam_apply
    @form.save_client
    flash[:success] = "稟議申請が完了しました。"
    redirect_to clients_list_path
  end

  def download
    file = find_file

    send_data(file.download,
    filename: file.filename.to_s,
    disposition: 'attachment',
    content_type: file.content_type)
  end

  def delete_file
    file = find_file
    file.purge

    redirect_to clients_exam_edit_path

  end

  private
  def client_params
    params.permit(:area_id,
                  :sb_tanto_id,
                  :name, :daihyo_name,
                  :zip_code, :zip_code,
                  :prefecture_code,
                  :address,
                  :tel,
                  :industry_id,
                  :industry_optional,
                  :established_in,
                  :annual_sales, :capital,
                  :tsr_score,
                  :tdb_score,
                  :anti_social,
                  :anti_social_memo,
                  :reject_reason,
                  :communicate_memo,
                  :registration_form_file,
                  other_files: [])
  end

  def load_client
    @sb_client = SbClient.find(params[:id])
  end

  def find_file
    sb_client = SbClient.find(params[:id])
    if params[:type] == "registration_form_file"
      file = sb_client.registration_form_file
    elsif params[:type] == "other_files"
      file = sb_client.other_files.find(params[:file_id])
    end
    return file
  end
end