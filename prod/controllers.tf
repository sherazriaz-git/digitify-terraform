data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
    # config_path = "~/.kube/config"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }


}


resource "helm_release" "aws-load-balancer-controller" {
  name         = "aws-load-balancer-controller"
  repository   = "https://aws.github.io/eks-charts"
  chart        = "aws-load-balancer-controller"
  namespace    = "kube-system"
  force_update = true
  set {
    name  = "image.repository"
    value = "public.ecr.aws/eks/aws-load-balancer-controller"
  }
  set {
    name  = "image.tag"
    value = "v2.10.1"
  }

  set {
    name  = "serviceAccountName"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_eks_role.iam_role_arn
  }
  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}


### metric server


resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = "kube-system"
}

# autoscaler

resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  set {
    name  = "fullnameOverride"
    value = "cluster-autoscaler"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_eks_role.iam_role_arn
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  set {
    name  = "awsRegion"
    value = var.region
  }


}
