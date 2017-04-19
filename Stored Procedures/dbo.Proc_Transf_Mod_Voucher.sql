SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Mod_Voucher]
@RucE nvarchar(11),
@Ejer varchar(4)
as
declare @Cd_Aux nvarchar(7)
declare @Cd_Fte varchar(2)
declare @Cd_Clt char(10)
declare @Cd_Prv char(7)
declare @IB_CtasXCbr bit
declare @IB_CtasXPag bit
declare @NroCta Varchar(15)

Declare _Cursor Cursor For 
            Select
                        NroCta, 
                        Cd_Aux,
                        Cd_Fte 
            From 
                        Voucher 
            Where 
                        len(Cd_Aux)<>0 
                        and RucE=@RucE 
                        and Ejer=@Ejer
            Order By Cd_Fte Desc
Open _Cursor
            Fetch Next From _Cursor Into @NroCta,@Cd_Aux,@Cd_Fte
            While @@Fetch_status = 0 
            Begin
                        If(@Cd_Fte='RC')
                        Begin
                                   Set @Cd_Prv=(Select Cd_Prv From Proveedor2 Where RucE=@RucE and CA10=@Cd_Aux)
                                   If(Isnull(Len(@Cd_Prv),0)<>0)
                                   Begin
												Update 
													Voucher 
												Set 
													Cd_Prv=@Cd_Prv, 
													Cd_Aux=Null 
												Where 
													RucE=@RucE 
													and Ejer=@Ejer 
													and Cd_Fte='RC' 
													and Cd_Aux=@Cd_Aux
									End
                        End 
                        Else If(@Cd_Fte='RV')
                        Begin
                                   Set @Cd_Clt=(Select Cd_Clt From Cliente2 Where Cd_Aux=@Cd_Aux and RucE=@RucE)
                                   If(Isnull(len(@Cd_Clt),0)<>0)
                                   Begin
												Update 
													Voucher 
												Set 
													Cd_Clt=@Cd_Clt, 
													Cd_Aux=Null 
												Where 
													RucE=@RucE 
													and Ejer=@Ejer 
													and Cd_Fte='RV' 
													and Cd_Aux=@Cd_Aux
                                   End
                        End
                        Else If(@Cd_Fte='CB' or @Cd_Fte='LD')
                        Begin
                                   Set @IB_CtasXCbr=(Select IB_CtasXCbr From PlanCtas Where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
                                   If(Isnull(@IB_CtasXCbr,0)<>0)
                                   Begin
                                               Set @Cd_Clt=(Select Cd_Clt From Cliente2 Where Cd_Aux=@Cd_Aux and RucE=@RucE)
                                               If(Isnull(Len(@Cd_Clt),0)<>0)
                                               Begin
													Update 
														Voucher 
													Set 
														Cd_Clt=@Cd_Clt, 
														Cd_Aux=Null 
													Where 
														RucE=@RucE 
														and Ejer=@Ejer 
														and NroCta=@NroCta 
														and Cd_Fte=@Cd_Fte 
														and Cd_Aux=@Cd_Aux
                                               End
                                   End
                                   Set @IB_CtasXPag=(Select IB_CtasXPag From PlanCtas Where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
                                   If(Isnull(@IB_CtasXPag,0)<>0)
                                   Begin
                                               Set @Cd_Prv=(Select Cd_Prv From Proveedor2 Where RucE=@RucE and CA10=@Cd_Aux)
                                               If(Isnull(Len(@Cd_Prv),0)<>0)
                                               Begin
													Update 
														Voucher 
													Set 
														Cd_Prv=@Cd_Prv, 
														Cd_Aux=Null 
													Where 
														RucE=@RucE 
														and Ejer=@Ejer 
														and NroCta=@NroCta 
														and Cd_Fte=@Cd_Fte 
														and Cd_Aux=@Cd_Aux
                                               End
                                   End
                        End
            Fetch Next From _Cursor Into @NroCta,@Cd_Aux,@Cd_Fte
            End
Close _Cursor
Deallocate _Cursor
GO
