/**
 * admin-data.js - 관리자 데이터 CRUD 공통 JS
 * 
 * 기능:
 * 1. 이미지 파일 업로드 미리보기
 * 2. 수정 모달에 기존 데이터 채우기
 * 3. 삭제 확인 다이얼로그
 */
document.addEventListener('DOMContentLoaded', function() {

    // ================================================================
    // 1. 이미지 파일 선택 시 미리보기
    // ================================================================
    document.querySelectorAll('.img-file-input').forEach(input => {
        input.addEventListener('change', function() {
            const preview = this.closest('.img-upload-wrapper').querySelector('.img-preview');
            const previewImg = preview?.querySelector('img');
            if (this.files && this.files[0] && previewImg) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    });

    // 1-1. 이미지 모드 토글 라디오 버튼 처리
    document.addEventListener('change', function(e) {
        if (e.target.name === 'imageMode') {
            const uploadWrapper = e.target.closest('form').querySelector('.img-upload-wrapper');
            const fileInput = uploadWrapper.querySelector('.img-file-input');
            const existingImgInput = uploadWrapper.querySelector('input[name="existingImageUrl"]');
            const preview = uploadWrapper.querySelector('.img-preview');
            
            if (e.target.value === 'DEFAULT') {
                uploadWrapper.style.display = 'none';
                fileInput.value = ''; // 첨부된 파일 무효화
                // 미리보기도 숨김
                if (preview) preview.style.display = 'none';
            } else {
                uploadWrapper.style.display = 'block';
                // 기존 이미지가 있으면 다시 보여줌
                if (existingImgInput && existingImgInput.value && existingImgInput.value.startsWith('/uploads/')) {
                    if (preview && preview.querySelector('img')) {
                        preview.querySelector('img').src = existingImgInput.value;
                        preview.style.display = 'block';
                    }
                }
            }
        }
    });

    // ================================================================
    // 2. 수정 모달 데이터 채우기
    //    수정 버튼 클릭 시 data-* 속성을 읽어 모달 폼에 채움
    // ================================================================
    document.querySelectorAll('.btn-admin-edit').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const modalId = this.dataset.modalTarget;
            const modal = document.getElementById(modalId);
            if (!modal) return;

            const form = modal.querySelector('form');
            // action을 update로 변경
            const updateAction = form.dataset.updateAction;
            form.action = updateAction;

            // 모달 제목 변경
            const titleEl = modal.querySelector('.modal-title');
            if (titleEl) {
                titleEl.innerHTML = '<i class="fas fa-edit me-2"></i>' + (this.dataset.editTitle || '데이터 수정');
            }

            // submit 버튼 텍스트 변경
            const submitBtn = modal.querySelector('.btn-admin-submit');
            if (submitBtn) submitBtn.textContent = '수정하기';

            // 데이터 필드 채우기
            const data = JSON.parse(this.dataset.item || '{}');
            Object.keys(data).forEach(key => {
                const checkbox = form.querySelector(`input[type="checkbox"][name="${key}"]`);
                if (checkbox) {
                    checkbox.checked = !!data[key];
                } else {
                    const input = form.querySelector(`[name="${key}"]`);
                    if (input) input.value = data[key] != null ? data[key] : '';
                }
            });

            // 기존 이미지 URL을 hidden 필드에 세팅 + 미리보기 및 모드 설정
            const existingImgInput = form.querySelector('input[name="existingImageUrl"]');
            if (existingImgInput && data.imageUrl) {
                existingImgInput.value = data.imageUrl;
            }
            
            const preview = form.querySelector('.img-preview');
            const previewImg = preview?.querySelector('img');
            const uploadWrapper = form.querySelector('.img-upload-wrapper');
            const radioDefault = form.querySelector('input[name="imageMode"][value="DEFAULT"]');
            const radioUpload = form.querySelector('input[name="imageMode"][value="UPLOAD"]');

            if (data.imageUrl && data.imageUrl.startsWith('/uploads/')) {
                // 업로드된 이미지인 경우
                if (radioUpload) {
                    radioUpload.checked = true;
                    if (uploadWrapper) uploadWrapper.style.display = 'block';
                }
                if (previewImg) {
                    previewImg.src = data.imageUrl;
                    if (preview) preview.style.display = 'block';
                }
            } else {
                // 기본 이미지이거나 없는 경우
                if (radioDefault) {
                    radioDefault.checked = true;
                    if (uploadWrapper) uploadWrapper.style.display = 'none';
                }
                if (preview) preview.style.display = 'none';
            }

            // Bootstrap 모달 열기
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        });
    });

    // ================================================================
    // 3. 추가 버튼 → 모달 초기화 (수정 후 다시 추가할 때)
    // ================================================================
    document.querySelectorAll('.btn-admin-add').forEach(btn => {
        btn.addEventListener('click', function() {
            const modalId = this.dataset.bsTarget;
            const modal = document.querySelector(modalId);
            if (!modal) return;

            const form = modal.querySelector('form');
            const addAction = form.dataset.addAction;
            if (addAction) form.action = addAction;

            // 모달 제목 복원
            const titleEl = modal.querySelector('.modal-title');
            const originalTitle = modal.dataset.addTitle;
            if (titleEl && originalTitle) {
                titleEl.innerHTML = '<i class="fas fa-plus-circle me-2"></i>' + originalTitle;
            }

            // submit 버튼 텍스트 복원
            const submitBtn = modal.querySelector('.btn-admin-submit');
            if (submitBtn) submitBtn.textContent = '추가하기';

            // 폼 초기화
            form.reset();
            // id hidden 필드 비우기
            const idInput = form.querySelector('input[name="id"]');
            if (idInput) idInput.value = '';
            // existingImageUrl 비우기
            const existingImgInput = form.querySelector('input[name="existingImageUrl"]');
            if (existingImgInput) existingImgInput.value = '';
            // 라디오 초기화
            const radioDefault = form.querySelector('input[name="imageMode"][value="DEFAULT"]');
            if (radioDefault) radioDefault.checked = true;
            // 미리보기 숨기고 업로드 폼 숨기기
            const preview = form.querySelector('.img-preview');
            if (preview) preview.style.display = 'none';
            const uploadWrapper = form.querySelector('.img-upload-wrapper');
            if (uploadWrapper) uploadWrapper.style.display = 'none';
        });
    });

    // ================================================================
    // 4. 삭제 확인 다이얼로그
    // ================================================================
    document.querySelectorAll('.btn-admin-delete').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const name = this.dataset.name || '이 항목';
            const deleteUrl = this.dataset.deleteUrl;
            const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

            if (confirm(`"${name}"을(를) 정말 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.`)) {
                // 동적 form 생성하여 POST 제출
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = deleteUrl;

                // CSRF 토큰
                if (csrfToken) {
                    const csrfInput = document.createElement('input');
                    csrfInput.type = 'hidden';
                    csrfInput.name = csrfHeader === 'X-CSRF-TOKEN' ? '_csrf' : '_csrf';
                    csrfInput.value = csrfToken;
                    form.appendChild(csrfInput);
                }

                document.body.appendChild(form);
                form.submit();
            }
        });
    });
});
