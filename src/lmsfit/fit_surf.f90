subroutine fit_surf(Nu,Nv,Nctlu,Nctlv,A,X,ctl)
!-----------------------------------------------------------------------
! Purpose: Fit_surf performs a constrained Least Mean Squares Fit on a
! set of x-y-z points in 3-space defined by a parametric values u,v. 
!
! Inputs:
!
! A: This is the matrix of partial derivaties of size M by N
!
! Nu: This is the number of datapoints in U we are fitting
! Nv: This is the number of datapoints in V we are fitting
!
! Nctlu,Nctlv: This is the number of control points we hav in u and v
! 
! X: Data we are trying to fit to
! ctl: Coefficients we are solving for

! Parameters

! Input/Output Variables
implicit none
integer, intent(in) :: Nu    ! Number of points in u
integer, intent(in) :: Nv    ! Number of points in v
integer, intent(in) :: Nctlu ! Number of control points in u
integer, intent(in) :: Nctlv ! Number of control points in v

double precision, intent(in) :: A(Nu*Nv,Nctlu*Nctlv)
double precision             :: A_temp(Nu*Nv,Nctlu*Nctlv)

double precision, intent(in) :: X(Nu,Nv,3)
double precision, intent(out):: ctl(Nctlu,Nctlv,3)

! Local Variables
double precision :: x_temp(Nu*Nv,1)
integer idim,i,j

!-- variables needed for QR decomposition
integer :: lwork, info
double precision :: work(2*Nctlu*Nctlv*Nu*Nv)
double precision err
character trans

external dgels ! Unconstrained

! Code for doing unconstrained least squares

do idim = 1,3
   do i=1,Nu
      do j=1,Nv
         X_temp((i-1)*Nv + j,1) = X(i,j,idim)
      end do
   end do
   trans = 'n'
   lwork = 2*Nctlu*Nctlv*Nu*Nv

   A_temp(:,:) = A(:,:) !This is necessary since A is overwritten for temporary storage

   !    dgels( TRANS,M    ,N          ,NRHS,A     ,LDA  ,B     ,LDB  ,WORK,LWORK,INFO)
   call dgels(trans ,Nu*Nv,Nctlu*Nctlv,   1,A_temp,Nu*Nv,X_temp,Nu*Nv,work,lwork,info)

   do i =1,Nctlu
      do j = 1,Nctlv
         ctl(i,j,idim) = X_temp((i-1)*Nctlv + j,1)
      end do
   end do
end do

end subroutine fit_surf
