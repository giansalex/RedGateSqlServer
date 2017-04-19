CREATE TABLE [dbo].[TipCam]
(
[FecTC] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[TCCom] [numeric] (13, 3) NOT NULL,
[TCVta] [numeric] (13, 3) NOT NULL,
[TCPro] [numeric] (13, 3) NOT NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipCam] ADD CONSTRAINT [PK_TipCam] PRIMARY KEY CLUSTERED  ([FecTC], [Cd_Mda]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipCam] WITH NOCHECK ADD CONSTRAINT [FK_TipCam_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
